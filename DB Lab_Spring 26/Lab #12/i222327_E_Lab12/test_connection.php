<?php
$pageTitle = 'Database test — SuperStore';
require_once __DIR__ . '/config/database.php';
$db = superstore_sqlsrv_connect();
$conn = $db['conn'];
$ok = (bool) $conn;
$errors = $db['errors'];
$config = superstore_db_config();

require __DIR__ . '/partials/head.php';
?>

<div class="card">
    <h2 class="card-title">Connection test</h2>
    <p class="card-sub">This page only checks that PHP can reach SQL Server with your credentials.</p>
    <p class="muted">Using server: <strong><?php echo htmlspecialchars($config['server'], ENT_QUOTES, 'UTF-8'); ?></strong>, database: <strong><?php echo htmlspecialchars($config['database'], ENT_QUOTES, 'UTF-8'); ?></strong> (see <code>config/database.php</code>).</p>

    <?php if ($ok) { ?>
        <div class="alert alert-success" role="status">Connection successful.</div>
        <p class="muted">You can return to the <a href="main_form.php">home</a> menu and use the other screens.</p>
    <?php } else { ?>
        <div class="alert alert-error" role="alert">Connection failed.</div>
        <?php if ($errors) { ?>
            <pre class="muted" style="white-space: pre-wrap; font-size: 0.8rem;"><?php echo htmlspecialchars(print_r($errors, true), ENT_QUOTES, 'UTF-8'); ?></pre>
        <?php } ?>
    <?php } ?>
</div>

<?php require __DIR__ . '/partials/footer.php'; ?>
