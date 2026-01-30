app_id := "app.glide_browser.glide"
manifest_file := (app_id + ".yml")
metainfo_file := (app_id + ".metainfo.xml")
desktop_file := (app_id + ".desktop")

_default:
	@just --list

build:
	@flatpak run org.flatpak.Builder \
		--user \
		--install \
		--install-deps-from=flathub \
		--force-clean \
		build \
		{{manifest_file}}

uninstall:
	flatpak remove --user --delete-data --assumeyes {{app_id}}

run:
	flatpak run --user {{app_id}}

shell:
	flatpak run \
		--user \
		--devel \
		--command=sh \
		{{app_id}}

[group('check')]
check: check-manifest check-metainfo check-desktop check-sources

[group('check')]
check-manifest:
	@echo "Checking Manifest"
	flatpak run --command="flatpak-builder-lint" org.flatpak.Builder "manifest" {{manifest_file}}

[group('check')]
check-metainfo:
	@echo "Checking Metainfo"
	flatpak run --command="appstreamcli" org.flatpak.Builder validate "--explain" {{metainfo_file}}

[group('check')]
check-desktop: 
	@echo "Checking Desktop File"
	flatpak run --command="desktop-file-validate" org.flatpak.Builder {{desktop_file}}

[group('check')]
check-sources:
	@echo "Checking External Data Sources"
	flatpak run org.flathub.flatpak-external-data-checker {{manifest_file}}

