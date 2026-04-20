<!DOCTYPE html>
<html lang="id">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Captain POS</title>
	<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

	<!-- Font Awesome -->
	{{ stylesheet_link("plugins/fontawesome-free/css/all.min.css") }}
	<!-- Favicon -->
	<link rel="shortcut icon" href="{{ url('dist/img/store_24x24.png') }}" type="image/x-icon">

	<!-- Google Fonts: Syne + DM Sans -->
	<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">

	<!-- jQuery -->
	{{ javascript_include("plugins/jquery/jquery.min.js") }}
	<!-- Bootstrap 4 -->
	{{ javascript_include("plugins/bootstrap/js/bootstrap.bundle.min.js") }}

	<style>
		*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

		:root {
			--gold: #C9A84C;
			--gold-light: #E8C97A;
			--gold-dim: rgba(201, 168, 76, 0.18);
			--dark-bg: #131313;
			--dark-surface: #13161D;
			--dark-card: #181C25;
			--dark-border: rgba(201, 168, 76, 0.2);
			--text-primary: #F0EDDF;
			--text-muted: #7A7D8A;
			--input-bg: #0F1219;
			--input-border: rgba(255,255,255,0.07);
			--input-focus: rgba(201, 168, 76, 0.35);
		}

		html, body {
			height: 100%;
			font-family: 'DM Sans', sans-serif;
			background-color: var(--dark-bg);
			color: var(--text-primary);
			overflow: hidden;
		}

		/* === BACKGROUND LAYERS === */
		.bg-layer {
			position: fixed;
			inset: 0;
			z-index: 0;
			background:
				radial-gradient(ellipse 60% 50% at 70% 20%, rgba(201,168,76,0.07) 0%, transparent 60%),
				radial-gradient(ellipse 50% 60% at 20% 80%, rgba(201,168,76,0.04) 0%, transparent 60%),
				var(--dark-bg);
		}

		.bg-grid {
			position: fixed;
			inset: 0;
			z-index: 0;
			background-image:
				linear-gradient(rgba(201,168,76,0.04) 1px, transparent 1px),
				linear-gradient(90deg, rgba(201,168,76,0.04) 1px, transparent 1px);
			background-size: 48px 48px;
			mask-image: radial-gradient(ellipse 80% 80% at 50% 50%, black 30%, transparent 100%);
		}

		/* === MAIN LAYOUT === */
		.login-wrapper {
			position: relative;
			z-index: 1;
			min-height: 100vh;
			display: flex;
			align-items: center;
			justify-content: center;
			padding: 2rem 1rem;
		}

		/* === CARD === */
		.login-card {
			width: 100%;
			max-width: 420px;
			background: var(--dark-card);
			border: 1px solid var(--dark-border);
			border-radius: 20px;
			overflow: hidden;
			position: relative;
		}

		.login-card::before {
			content: '';
			position: absolute;
			top: 0; left: 0; right: 0;
			height: 1px;
			background: linear-gradient(90deg, transparent, var(--gold), transparent);
		}

		/* === CARD HEADER === */
		.card-header-custom {
			padding: 2.5rem 2.5rem 1.5rem;
			text-align: center;
		}

		.brand-icon {
			width: 60px;
			height: 60px;
			margin: 0 auto 1.25rem;
			background: var(--gold-dim);
			border: 1px solid rgba(201,168,76,0.3);
			border-radius: 16px;
			display: flex;
			align-items: center;
			justify-content: center;
			font-size: 24px;
			color: var(--gold);
		}

		.brand-name {
			font-family: 'Syne', sans-serif;
			font-size: 1.6rem;
			font-weight: 800;
			letter-spacing: -0.5px;
			color: var(--text-primary);
			line-height: 1;
		}

		.brand-name span {
			color: var(--gold);
		}

		.brand-subtitle {
			margin-top: 0.4rem;
			font-size: 0.8rem;
			font-weight: 300;
			color: var(--text-muted);
			letter-spacing: 2px;
			text-transform: uppercase;
		}

		/* === CARD BODY === */
		.card-body-custom {
			padding: 0.5rem 2.5rem 2rem;
		}

		.section-label {
			font-size: 0.78rem;
			font-weight: 500;
			color: var(--text-muted);
			letter-spacing: 1.5px;
			text-transform: uppercase;
			margin-bottom: 1.5rem;
			display: flex;
			align-items: center;
			gap: 10px;
		}

		.section-label::before,
		.section-label::after {
			content: '';
			flex: 1;
			height: 1px;
			background: var(--input-border);
		}

		/* === INPUT FIELDS === */
		.field-group {
			margin-bottom: 1rem;
		}

		.field-label {
			display: block;
			font-size: 0.75rem;
			font-weight: 500;
			color: var(--text-muted);
			letter-spacing: 0.5px;
			margin-bottom: 0.45rem;
			text-transform: uppercase;
		}

		.input-wrap {
			position: relative;
		}

		.input-wrap .icon {
			position: absolute;
			left: 14px;
			top: 50%;
			transform: translateY(-50%);
			font-size: 14px;
			color: var(--text-muted);
			pointer-events: none;
			transition: color 0.2s;
		}

		.input-wrap input {
			width: 100%;
			height: 48px;
			background: var(--input-bg);
			border: 1px solid var(--input-border);
			border-radius: 10px;
			padding: 0 14px 0 42px;
			font-family: 'DM Sans', sans-serif;
			font-size: 0.9rem;
			font-weight: 400;
			color: var(--text-primary);
			outline: none;
			transition: border-color 0.2s, box-shadow 0.2s;
		}

		.input-wrap input::placeholder {
			color: var(--text-muted);
			opacity: 0.6;
		}

		.input-wrap input:focus {
			border-color: rgba(201,168,76,0.5);
			box-shadow: 0 0 0 3px var(--input-focus);
		}

		.input-wrap input:focus + .icon,
		.input-wrap:focus-within .icon {
			color: var(--gold);
		}

		/* fix: icon color on focus */
		.input-wrap:focus-within .icon {
			color: var(--gold);
		}

		/* === SHOW/HIDE PASSWORD === */
		.toggle-pw {
			position: absolute;
			right: 14px;
			top: 50%;
			transform: translateY(-50%);
			background: none;
			border: none;
			color: var(--text-muted);
			cursor: pointer;
			padding: 0;
			font-size: 13px;
			transition: color 0.2s;
		}
		.toggle-pw:hover { color: var(--gold-light); }

		/* === SUBMIT BUTTON === */
		.btn-login {
			width: 100%;
			height: 50px;
			margin-top: 1.5rem;
			background: linear-gradient(135deg, #C9A84C, #E8C97A);
			border: none;
			border-radius: 10px;
			font-family: 'Syne', sans-serif;
			font-size: 0.95rem;
			font-weight: 700;
			color: #0D0F14;
			letter-spacing: 0.5px;
			cursor: pointer;
			position: relative;
			overflow: hidden;
			transition: opacity 0.2s, transform 0.15s;
		}

		.btn-login::after {
			content: '';
			position: absolute;
			inset: 0;
			background: linear-gradient(135deg, rgba(255,255,255,0.12), transparent);
		}

		.btn-login:hover {
			opacity: 0.92;
			transform: translateY(-1px);
		}

		.btn-login:active {
			transform: translateY(0);
			opacity: 1;
		}

		/* === FORGOT LINK === */
		.forgot-link {
			display: block;
			text-align: center;
			margin-top: 1.25rem;
			font-size: 0.8rem;
			color: var(--text-muted);
			text-decoration: none;
			transition: color 0.2s;
		}
		.forgot-link:hover { color: var(--gold-light); text-decoration: none; }

		/* === FOOTER === */
		.card-footer-custom {
			border-top: 1px solid var(--input-border);
			padding: 1rem 2.5rem;
			display: flex;
			align-items: center;
			justify-content: space-between;
		}

		.footer-info {
			font-size: 0.72rem;
			color: var(--text-muted);
			letter-spacing: 0.3px;
		}

		.footer-badge {
			font-size: 0.68rem;
			font-family: 'Syne', sans-serif;
			font-weight: 600;
			color: var(--gold);
			background: var(--gold-dim);
			border: 1px solid rgba(201,168,76,0.2);
			padding: 3px 10px;
			border-radius: 20px;
			letter-spacing: 0.5px;
		}

		/* === FADE IN === */
		.login-card {
			animation: fadeUp 0.5s cubic-bezier(0.22, 1, 0.36, 1) both;
		}

		@keyframes fadeUp {
			from { opacity: 0; transform: translateY(24px); }
			to   { opacity: 1; transform: translateY(0); }
		}
	</style>
</head>

<body>

<div class="bg-layer"></div>
<div class="bg-grid"></div>

<div class="login-wrapper">
	<div class="login-card">

		<!-- HEADER -->
		<div class="card-header-custom">
			<div class="brand-icon">
				<i class="fas fa-store"></i>
			</div>
			<div class="brand-name">Captain <span>POS</span></div>
			<div class="brand-subtitle">Point of Sales System</div>
		</div>

		<!-- BODY -->
		<div class="card-body-custom">
			<div class="section-label">Masuk ke akun Anda</div>

			<form action="{{ url('login/proses') }}" method="POST" autocomplete="off">
				<!-- Username -->
				<div class="field-group">
					<label class="field-label" for="txtusername">Username</label>
					<div class="input-wrap">
						<i class="fas fa-user icon"></i>
						<input type="text" id="txtusername" name="txtusername" placeholder="Masukkan username">
					</div>
				</div>

				<!-- Password -->
				<div class="field-group">
					<label class="field-label" for="txtpassword">Password</label>
					<div class="input-wrap">
						<i class="fas fa-lock icon"></i>
						<input type="password" id="txtpassword" name="txtpassword" placeholder="Masukkan password">
						<button type="button" class="toggle-pw" id="togglePw" tabindex="-1">
							<i class="fas fa-eye" id="pwIcon"></i>
						</button>
					</div>
				</div>

				<button type="submit" class="btn-login">
					Masuk &nbsp;<i class="fas fa-arrow-right" style="font-size:12px;"></i>
				</button>
			</form>

			<a href="{{ url('login/forgot') }}" class="forgot-link">
				<i class="fas fa-key" style="font-size:11px; margin-right:5px;"></i>Lupa password?
			</a>
		</div>

		<!-- FOOTER -->
		<div class="card-footer-custom">
			<span class="footer-info">&copy; {{ date('Y') }} Captain POS</span>
			<span class="footer-badge">v2.0</span>
		</div>

	</div>
</div>

<script>
	history.pushState(null, null, "{{ url('') }}");

	$(document).ready(function () {
		$("#txtusername").focus();

		// toggle show/hide password
		$("#togglePw").on("click", function () {
			var input = $("#txtpassword");
			var icon  = $("#pwIcon");
			if (input.attr("type") === "password") {
				input.attr("type", "text");
				icon.removeClass("fa-eye").addClass("fa-eye-slash");
			} else {
				input.attr("type", "password");
				icon.removeClass("fa-eye-slash").addClass("fa-eye");
			}
		});
	});
</script>

</body>
</html>
