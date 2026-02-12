# Download and install ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
sudo tar xvzf ./ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin
# OR
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
  | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
  && echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" \
  | sudo tee /etc/apt/sources.list.d/ngrok.list \
  && sudo apt update \
  && sudo apt install ngrok
# you can also install ngrok via snap: sudo apt install snapd then sudo snap install ngrok

# Verify ngrok installation
ngrok version

# Add your ngrok auth token (replace YOUR_AUTH_TOKEN with your actual token)
ngrok config add-authtoken YOUR_AUTH_TOKEN

# Run ngrok to expose your local web server
ngrok http 80

################## WordPress Configuration ##################
// Detect HTTPS request (ngrok or proxy)
$is_https = false;
if (!empty($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
	$is_https = true;
} elseif (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') {
	$is_https = true;
}
// If HTTPS request, dynamically set WP URLs
if ($is_https) {
	// Fallback if SERVER_NAME missing
	if (!$host && !empty($_SERVER['HTTP_HOST'])) {
		$host = preg_replace('/:\d+$/', '', $_SERVER['HTTP_HOST']); // remove port
	}

	if ($host) {
		define('WP_HOME', 'https://' . $host . '/websitename');
		define('WP_SITEURL', 'https://' . $host . '/websitename');
	}

	$_SERVER['HTTPS'] = 'on';
}