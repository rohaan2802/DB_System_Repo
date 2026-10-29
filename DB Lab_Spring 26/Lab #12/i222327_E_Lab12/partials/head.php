<?php
if (!isset($pageTitle)) {
    $pageTitle = 'SuperStore';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($pageTitle, ENT_QUOTES, 'UTF-8'); ?></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;1,9..40,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <a class="skip-link" href="#main-content">Skip to content</a>
    <div class="app-bg"></div>
    <div class="app-wrap">
        <header class="site-header">
            <a class="brand" href="main_form.php">SuperStore</a>
            <nav class="site-nav" aria-label="Primary">
                <a href="main_form.php" class="nav-link">Home</a>
                <a href="customer_order_form.php" class="nav-link">Orders</a>
                <a href="customer_master_form.php" class="nav-link">Customers</a>
                <a href="product_master_form.php" class="nav-link">Products</a>
                <a href="customer_order_output.php" class="nav-link">View order</a>
            </nav>
        </header>
        <main id="main-content" class="main-area">
