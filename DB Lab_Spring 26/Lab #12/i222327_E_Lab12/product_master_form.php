<?php
$pageTitle = 'Products — SuperStore';
require_once __DIR__ . '/config/database.php';
$db = superstore_sqlsrv_connect();
$conn = $db['conn'];
$product = null;
$supplier = null;
$dbError = '';
$addError = '';
$addSuccess = '';

$allProducts = array();
if ($conn) {
    $stmtAll = sqlsrv_query($conn, 'SELECT Pid, PName, PPrice, PQty FROM Product ORDER BY Pid ASC');
    if ($stmtAll !== false) {
        while ($row = sqlsrv_fetch_array($stmtAll, SQLSRV_FETCH_ASSOC)) {
            $allProducts[] = $row;
        }
        sqlsrv_free_stmt($stmtAll);
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['add_product'])) {
    if (!$conn) {
        $addError = superstore_connect_error_message($db['errors']);
    } else {
        $newPid = isset($_POST['new_Pid']) ? (int) $_POST['new_Pid'] : 0;
        $newName = isset($_POST['new_PName']) ? trim((string) $_POST['new_PName']) : '';
        $newPrice = isset($_POST['new_PPrice']) ? (float) $_POST['new_PPrice'] : 0;
        $newQty = isset($_POST['new_PQty']) ? (int) $_POST['new_PQty'] : 0;

        if ($newPid < 1) {
            $addError = 'Product ID must be a positive number.';
        } elseif ($newName === '') {
            $addError = 'Product name is required.';
        } elseif ($newPrice < 0) {
            $addError = 'Price cannot be negative.';
        } elseif ($newQty < 0) {
            $addError = 'Stock quantity cannot be negative.';
        } else {
            $sqlIns = 'INSERT INTO Product (Pid, PName, PPrice, PQty) VALUES (?, ?, ?, ?)';
            $stmtIns = sqlsrv_query($conn, $sqlIns, array($newPid, $newName, $newPrice, $newQty));
            if ($stmtIns === false) {
                $addError = 'Could not add product. The ID may already exist or the data is invalid.';
            } else {
                $addSuccess = 'Product added successfully.';
                sqlsrv_free_stmt($stmtIns);
                $allProducts = array();
                $stmtAll = sqlsrv_query($conn, 'SELECT Pid, PName, PPrice, PQty FROM Product ORDER BY Pid ASC');
                if ($stmtAll !== false) {
                    while ($row = sqlsrv_fetch_array($stmtAll, SQLSRV_FETCH_ASSOC)) {
                        $allProducts[] = $row;
                    }
                    sqlsrv_free_stmt($stmtAll);
                }
            }
        }
    }
}

$productID = isset($_GET['ProductID']) ? (int) $_GET['ProductID'] : 0;

if (!$conn) {
    $dbError = superstore_connect_error_message($db['errors']);
} elseif ($productID > 0) {
    $sql = 'SELECT * FROM Product WHERE Pid = ?';
    $stmt = sqlsrv_query($conn, $sql, array($productID));
    if ($stmt === false) {
        $dbError = 'Query failed.';
    } else {
        $product = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
        sqlsrv_free_stmt($stmt);
    }

    if ($product && isset($product['SupId']) && $product['SupId'] !== null) {
        $sqlSupplier = 'SELECT * FROM Supplier WHERE SupId = ?';
        $stmtS = sqlsrv_query($conn, $sqlSupplier, array($product['SupId']));
        if ($stmtS) {
            $supplier = sqlsrv_fetch_array($stmtS, SQLSRV_FETCH_ASSOC);
            sqlsrv_free_stmt($stmtS);
        }
    }
}

require __DIR__ . '/partials/head.php';
?>

<div class="card card-wide">
    <h2 class="card-title">Products</h2>
    <p class="card-sub">Add new products here. They appear immediately in the list and on the order form.</p>

    <?php if ($dbError !== '' && !$conn) { ?>
        <div class="alert alert-error" role="alert"><?php echo htmlspecialchars($dbError, ENT_QUOTES, 'UTF-8'); ?></div>
    <?php } ?>

    <?php if ($addError !== '') { ?>
        <div class="alert alert-error" role="alert"><?php echo htmlspecialchars($addError, ENT_QUOTES, 'UTF-8'); ?></div>
    <?php } ?>
    <?php if ($addSuccess !== '') { ?>
        <div class="alert alert-success" role="status"><?php echo htmlspecialchars($addSuccess, ENT_QUOTES, 'UTF-8'); ?></div>
    <?php } ?>

    <?php if ($conn) { ?>
        <h3 class="subsection-title">Add product</h3>
        <form method="post" action="product_master_form.php" class="add-product-form">
            <input type="hidden" name="add_product" value="1">
            <div class="form-row form-row-four">
                <div class="form-group">
                    <label class="form-label" for="new_Pid">Product ID</label>
                    <input type="number" id="new_Pid" name="new_Pid" required min="1" value="<?php echo isset($_POST['new_Pid']) ? (int) $_POST['new_Pid'] : ''; ?>">
                </div>
                <div class="form-group">
                    <label class="form-label" for="new_PName">Name</label>
                    <input type="text" id="new_PName" name="new_PName" required maxlength="100" value="<?php echo isset($_POST['new_PName']) ? htmlspecialchars((string) $_POST['new_PName'], ENT_QUOTES, 'UTF-8') : ''; ?>">
                </div>
                <div class="form-group">
                    <label class="form-label" for="new_PPrice">Price</label>
                    <input type="number" id="new_PPrice" name="new_PPrice" required min="0" step="0.01" value="<?php echo isset($_POST['new_PPrice']) ? htmlspecialchars((string) $_POST['new_PPrice'], ENT_QUOTES, 'UTF-8') : ''; ?>">
                </div>
                <div class="form-group">
                    <label class="form-label" for="new_PQty">Stock qty</label>
                    <input type="number" id="new_PQty" name="new_PQty" required min="0" value="<?php echo isset($_POST['new_PQty']) ? htmlspecialchars((string) $_POST['new_PQty'], ENT_QUOTES, 'UTF-8') : ''; ?>">
                </div>
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-primary" style="width: auto; min-width: 160px;">Add product</button>
            </div>
        </form>

        <h3 class="subsection-title">All products</h3>
        <?php if (count($allProducts) > 0) { ?>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Stock</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($allProducts as $p) { ?>
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
        <?php } else { ?>
            <p class="muted">No products yet. Use the form above to add the first one.</p>
        <?php } ?>
    <?php } ?>

    <h3 class="subsection-title">Look up one product</h3>
    <p class="muted" style="margin-bottom: 1rem;">Enter an ID to see full details.</p>

    <?php if ($dbError !== '' && $conn) { ?>
        <div class="alert alert-error" role="alert"><?php echo htmlspecialchars($dbError, ENT_QUOTES, 'UTF-8'); ?></div>
    <?php } ?>

    <form class="lookup-form" method="get" action="product_master_form.php">
        <div class="form-group">
            <label class="form-label" for="ProductID">Product ID</label>
            <input type="number" id="ProductID" name="ProductID" required min="1" value="<?php echo $productID > 0 ? (int) $productID : ''; ?>" placeholder="e.g. 1">
        </div>
        <button type="submit" class="btn btn-primary">Load product</button>
    </form>

    <?php if ($conn && $productID > 0 && $product) { ?>
        <h3 class="subsection-title">Details</h3>
        <dl class="detail-list">
            <div class="detail-pair"><dt>Product ID</dt><dd><?php echo htmlspecialchars((string) $product['Pid'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
            <div class="detail-pair"><dt>Name</dt><dd><?php echo htmlspecialchars((string) $product['PName'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
            <div class="detail-pair"><dt>Price</dt><dd><?php echo htmlspecialchars((string) $product['PPrice'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
            <div class="detail-pair"><dt>Qty in stock</dt><dd><?php echo htmlspecialchars((string) $product['PQty'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
        </dl>

        <?php if ($supplier) { ?>
            <h3 class="subsection-title">Supplier</h3>
            <dl class="detail-list">
                <div class="detail-pair"><dt>Name</dt><dd><?php echo htmlspecialchars((string) $supplier['SupName'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
                <div class="detail-pair"><dt>Telephone</dt><dd><?php echo htmlspecialchars((string) $supplier['TelNo'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
                <div class="detail-pair"><dt>City</dt><dd><?php echo htmlspecialchars((string) $supplier['City'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
                <div class="detail-pair"><dt>Address</dt><dd><?php echo htmlspecialchars((string) $supplier['Address'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
            </dl>
        <?php } ?>
    <?php } elseif ($conn && $productID > 0 && $dbError === '') { ?>
        <p class="muted">No product found for ID <?php echo (int) $productID; ?>.</p>
    <?php } ?>
</div>

<?php require __DIR__ . '/partials/footer.php'; ?>
