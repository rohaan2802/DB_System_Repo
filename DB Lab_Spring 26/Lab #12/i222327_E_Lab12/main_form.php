<?php $pageTitle = 'Home — SuperStore'; ?>
<?php require __DIR__ . '/partials/head.php'; ?>

<div class="card">
    <h1 class="card-title">SuperStore Management</h1>
    <p class="card-sub">Choose a task below. Each screen includes lookups, forms, and clear feedback.</p>
    <div class="menu-grid">
        <a class="menu-btn" href="customer_order_form.php">Place customer order</a>
        <a class="menu-btn secondary" href="customer_master_form.php">Look up customer</a>
        <a class="menu-btn secondary" href="product_master_form.php">Look up product</a>
        <a class="menu-btn secondary" href="customer_order_output.php">View invoice / order</a>
    </div>
</div>

<?php require __DIR__ . '/partials/footer.php'; ?>
