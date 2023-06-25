domain="test.straylightsecurity.com"
caddy_config="$domain {
    handle {
            reverse_proxy localhost:8443 {
	                header_up Host {host}
			            header_up X-Real-IP {remote}
				                header_up X-Forwarded-For {remote}
						            header_up X-Forwarded-Port {server_port}
							                header_up X-Forwarded-Proto {scheme}
									        }
									    }

								        handle_path /static* {
									        reverse_proxy localhost:5000 {
										            header_up Host {host}
											                header_up X-Real-IP {remote}
													            header_up X-Forwarded-For {remote}
														                header_up X-Forwarded-Port {server_port}
																            header_up X-Forwarded-Proto {scheme}
																	                transport http {
																			                tls_insecure_skip_verify
																					            }
																					            }
																					        }
																				}"
																			echo $caddy_config > ~/Caddyfile
																			echo $caddy_config > /etc/caddy/Caddyfile
