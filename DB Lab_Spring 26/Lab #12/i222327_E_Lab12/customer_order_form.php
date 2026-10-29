<?php
$pageTitle = 'Place order — SuperStore';
require_once __DIR__ . '/config/database.php';
$db = superstore_sqlsrv_connect();
$conn = $db['conn'];
$dbError = !$conn ? superstore_connect_error_message($db['errors']) : '';
$formError = '';
$formSuccess = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!$conn) {
        $formError = $dbError;
    } elseif (
        empty($_POST['Products']) || !is_array($_POST['Products'])
        || empty($_POST['Qty']) || !is_array($_POST['Qty'])
        || empty($_POST['Price']) || !is_array($_POST['Price'])
    ) {
        $formError = 'Please add at least one complete product line (ID, quantity, and price).';
    } else {
        $cid = $_POST['Cid'];
        $empid = $_POST['Empid'];
        $shipid = $_POST['Shipid'];
        $invDate = $_POST['InvDate'];
        $totalAmount = $_POST['TotalAmount'];

        $sql = 'INSERT INTO Invoice (Cid, InvDate, TotalAmount, Empid, Shipid) OUTPUT INSERTED.[Inv#] AS newInv VALUES (?, ?, ?, ?, ?)';
        $params = array($cid, $invDate, $totalAmount, $empid, $shipid);
        $stmt = sqlsrv_query($conn, $sql, $params);

        if ($stmt === false) {
            $formError = 'Could not save invoice. Check IDs exist (customer, employee, shipper) and try again.';
        } else {
            $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
            $invID = $row ? $row['newInv'] : null;
            sqlsrv_free_stmt($stmt);

            if ($invID === null) {
                $formError = 'Invoice was created but the new invoice number could not be read.';
            } else {
                $detailOk = true;
                foreach ($_POST['Products'] as $lineKey => $pid) {
                    if ($pid === '' || $pid === null) {
                        continue;
                    }
                    $qty = isset($_POST['Qty'][$lineKey]) ? $_POST['Qty'][$lineKey] : 0;
                    $price = isset($_POST['Price'][$lineKey]) ? $_POST['Price'][$lineKey] : 0;
                    $extendPrice = (float) $qty * (float) $price;
                    $sqlDetail = 'INSERT INTO OrderDetail ([Inv#], Pid, Qty, SPrice, ExtendPrice) VALUES (?, ?, ?, ?, ?)';
                    $paramsDetail = array($invID, $pid, $qty, $price, $extendPrice);
                    if (sqlsrv_query($conn, $sqlDetail, $paramsDetail) === false) {
                        $detailOk = false;
                        break;
                    }
                }
                if ($detailOk) {
                    $formSuccess = 'Order saved successfully. Invoice #' . (int) $invID . '.';
                } else {
                    $formError = 'Invoice #' . (int) $invID . ' was created but one or more line items failed. Check product IDs.';
                }
            }
        }
    }
}

$catalogProducts = array();
if ($conn) {
    $stmtCat = sqlsrv_query($conn, 'SELECT Pid, PName, PPrice, PQty FROM Product ORDER BY Pid ASC');
    if ($stmtCat !== false) {
        while ($row = sqlsrv_fetch_array($stmtCat, SQLSRV_FETCH_ASSOC)) {
            $catalogProducts[] = $row;
        }
        sqlsrv_free_stmt($stmtCat);
    }
}

$catalogForJs = array();
foreach ($catalogProducts as $row) {
    $catalogForJs[] = array(
        'id' => (int) $row['Pid'],
        'name' => (string) $row['PName'],
        'price' => (float) $row['PPrice'],
    );
}

require __DIR__ . '/partials/head.php';
?>

<div class="card card-wide">
    <h2 class="card-title">Place customer order</h2>
    <p class="card-sub">Complete the header and line items, then submit. Use the product dropdown on each line to set ID and price.</p>

    <?php if ($conn && count($catalogProducts) > 0) { ?>
        <div class="product-catalog-panel">
            <h4 class="product-catalog-title">Products in database</h4>
            <div class="table-wrap">
                <table class="product-catalog-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Stock</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($catalogProducts as $p) { ?>
                            <tr>
                                <td><?php echo (int) $p['Pid']; ?></td>
                                <td><?php echo htmlspecialchars((string) $p['PName'], ENT_QUOTES, 'UTF-8'); ?></td>
                                <td><?php echo htmlspecialchars((string) $p['PPrice'], ENT_QUOTES, 'UTF-8'); ?></td>
                                <td><?php echo htmlspecialchars((string) $p['PQty'], ENT_QUOTES, 'UTF-8'); ?></td>
                            </tr>
                        <?php } ?>
                    </tbody>
                </table>
            </div>
        </div>
    <?php } elseif ($conn && count($catalogProducts) === 0) { ?>
        <p class="muted">No products in the database yet. Add rows to the <code>Product</code> table or run your SQL seed script.</p>
    <?php } ?>

    <?php if ($dbError !== '') { ?>
        <div class="alert alert-error" role="alert"><?php echo htmlspecialchars($dbError, ENT_QUOTES, 'UTF-8'); ?></div>
        <p class="form-hint">Edit server name in <code>config/database.php</code> (try <code>localhost\\SQLEXPRESS</code> or your instance). Orders used to hide this until you clicked Submit.</p>
    <?php } ?>

    <?php if ($formError !== '') { ?>
        <div class="alert alert-error" role="alert"><?php echo htmlspecialchars($formError, ENT_QUOTES, 'UTF-8'); ?></div>
    <?php } ?>
    <?php if ($formSuccess !== '') { ?>
        <div class="alert alert-success" role="status"><?php echo htmlspecialchars($formSuccess, ENT_QUOTES, 'UTF-8'); ?></div>
    <?php } ?>

    <form method="post" action="customer_order_form.php" id="orderForm" novalidate>
        <div class="form-row">
            <div class="form-group">
                <label class="form-label" for="Cid">Customer ID</label>
                <input type="number" id="Cid" name="Cid" required min="1" value="<?php echo isset($_POST['Cid']) ? htmlspecialchars((string) $_POST['Cid'], ENT_QUOTES, 'UTF-8') : ''; ?>">
            </div>
            <div class="form-group">
                <label class="form-label" for="Empid">Employee ID</label>
                <input type="number" id="Empid" name="Empid" required min="1" value="<?php echo isset($_POST['Empid']) ? htmlspecialchars((string) $_POST['Empid'], ENT_QUOTES, 'UTF-8') : ''; ?>">
            </div>
        </div>
        <div class="form-row">
            <div class="form-group">
                <label class="form-label" for="Shipid">Shipper ID</label>
                <input type="number" id="Shipid" name="Shipid" required min="1" value="<?php echo isset($_POST['Shipid']) ? htmlspecialchars((string) $_POST['Shipid'], ENT_QUOTES, 'UTF-8') : ''; ?>">
            </div>
            <div class="form-group">
                <label class="form-label" for="InvDate">Invoice date</label>
                <input type="date" id="InvDate" name="InvDate" required value="<?php echo isset($_POST['InvDate']) ? htmlspecialchars((string) $_POST['InvDate'], ENT_QUOTES, 'UTF-8') : date('Y-m-d'); ?>">
            </div>
        </div>
        <div class="form-group">
            <label class="form-label" for="TotalAmount">Total amount</label>
            <input type="number" id="TotalAmount" name="TotalAmount" step="0.01" min="0" required value="<?php echo isset($_POST['TotalAmount']) ? htmlspecialchars((string) $_POST['TotalAmount'], ENT_QUOTES, 'UTF-8') : ''; ?>">
            <p class="form-hint">Should match the sum of line extended prices for accurate reporting.</p>
        </div>

        <h3 class="product-section-title">Line items</h3>
        <div id="productSection" class="product-section">
            <div class="product-line" data-line="1">
                <div class="product-line-header">
                    <span>Item 1</span>
                </div>
                <div class="form-group">
                    <label class="form-label" for="pick_1">Select product</label>
                    <select id="pick_1" class="product-picker" title="Fills product ID and unit price for this line">
                        <option value="">— Select product —</option>
                        <?php foreach ($catalogProducts as $p) {
                            $pid = (int) $p['Pid'];
                            $pprice = htmlspecialchars((string) $p['PPrice'], ENT_QUOTES, 'UTF-8');
                            $pname = htmlspecialchars((string) $p['PName'], ENT_QUOTES, 'UTF-8');
                            ?>
                            <option value="<?php echo $pid; ?>" data-price="<?php echo $pprice; ?>"><?php echo $pname; ?> (ID <?php echo $pid; ?>)</option>
                        <?php } ?>
                    </select>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="product_1">Product ID</label>
                        <input type="number" id="product_1" name="Products[1]" required min="1" class="line-pid">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="qty_1">Quantity</label>
                        <input type="number" id="qty_1" name="Qty[1]" required min="1" class="line-qty">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="price_1">Unit price</label>
                        <input type="number" id="price_1" name="Price[1]" step="0.01" min="0" required class="line-price">
                    </div>
                </div>
            </div>
        </div>

        <div class="form-group" style="margin-top: 1rem;">
            <button type="button" id="addProductButton" class="btn btn-secondary">+ Add another product</button>
        </div>
        <div class="form-group">
            <button type="submit" class="btn submit-btn">Submit order</button>
        </div>
    </form>
</div>

<script>
window.SUPERSTORE_PRODUCTS = <?php echo json_encode($catalogForJs, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_UNESCAPED_UNICODE); ?>;
</script>
<script>
(function () {
    let productCount = 1;
    const section = document.getElementById('productSection');
    const addBtn = document.getElementById('addProductButton');
    const products = window.SUPERSTORE_PRODUCTS || [];

    function fillProductSelect(selectEl) {
        selectEl.innerHTML = '';
        var placeholder = document.createElement('option');
        placeholder.value = '';
        placeholder.textContent = '— Select product —';
        selectEl.appendChild(placeholder);
        products.forEach(function (p) {
            var opt = document.createElement('option');
            opt.value = String(p.id);
            opt.setAttribute('data-price', String(p.price));
            opt.textContent = p.name + ' (ID ' + p.id + ')';
            selectEl.appendChild(opt);
        });
    }

    function applyProductPick(selectEl) {
        var line = selectEl.closest('.product-line');
        if (!line) return;
        var pidInput = line.querySelector('.line-pid');
        var priceInput = line.querySelector('.line-price');
        var opt = selectEl.options[selectEl.selectedIndex];
        if (!selectEl.value) return;
        if (pidInput) pidInput.value = selectEl.value;
        if (priceInput && opt && opt.getAttribute('data-price') !== null) {
            priceInput.value = opt.getAttribute('data-price');
        }
    }

    section.addEventListener('change', function (e) {
        if (!e.target.classList.contains('product-picker')) return;
        applyProductPick(e.target);
    });

    function refreshLineHeaders() {
        section.querySelectorAll('.product-line').forEach(function (line, index) {
            const h = line.querySelector('.product-line-header span');
            if (h) h.textContent = 'Item ' + (index + 1);
        });
    }

    function addRemoveHandler(line) {
        const hdr = line.querySelector('.product-line-header');
        if (section.querySelectorAll('.product-line').length <= 1) {
            var oldRm = hdr.querySelector('.btn-ghost');
            if (oldRm) oldRm.remove();
            return;
        }
        if (!hdr.querySelector('.btn-ghost')) {
            const rm = document.createElement('button');
            rm.type = 'button';
            rm.className = 'btn btn-ghost';
            rm.textContent = 'Remove';
            rm.addEventListener('click', function () {
                line.remove();
                refreshLineHeaders();
            });
            hdr.appendChild(rm);
        }
    }

    addBtn.addEventListener('click', function () {
        productCount++;
        const line = document.createElement('div');
        line.className = 'product-line';
        line.dataset.line = String(productCount);
        line.innerHTML =
            '<div class="product-line-header"><span>Item</span></div>' +
            '<div class="form-group">' +
            '<label class="form-label" for="pick_' + productCount + '">Select product</label>' +
            '<select id="pick_' + productCount + '" class="product-picker" title="Fills product ID and unit price for this line"></select>' +
            '</div>' +
            '<div class="form-row">' +
            '<div class="form-group"><label class="form-label" for="product_' + productCount + '">Product ID</label>' +
            '<input type="number" id="product_' + productCount + '" name="Products[' + productCount + ']" required min="1" class="line-pid"></div>' +
            '<div class="form-group"><label class="form-label" for="qty_' + productCount + '">Quantity</label>' +
            '<input type="number" id="qty_' + productCount + '" name="Qty[' + productCount + ']" required min="1" class="line-qty"></div>' +
            '<div class="form-group"><label class="form-label" for="price_' + productCount + '">Unit price</label>' +
            '<input type="number" id="price_' + productCount + '" name="Price[' + productCount + ']" step="0.01" min="0" required class="line-price"></div>' +
            '</div>';
        section.appendChild(line);
        var newPick = line.querySelector('.product-picker');
        if (newPick) fillProductSelect(newPick);
        section.querySelectorAll('.product-line').forEach(addRemoveHandler);
        refreshLineHeaders();
    });

    section.querySelectorAll('.product-line').forEach(addRemoveHandler);
})();
</script>

<?php require __DIR__ . '/partials/footer.php'; ?>
