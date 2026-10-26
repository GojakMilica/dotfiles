cat > ~/dotfiles/CLAUDE.md << 'EOF'
# Dotfiles (Arch + Hyprland)

- Repo se linkuje sa GNU stow. Hyprland config: hypr/.config/hypr/hyprland.lua
- Hyprland 0.55+, config je u Lua formatu. Pre izmene proveri sintaksu u zvaničnoj wiki (wiki.hypr.land) ili u postojećem fajlu. Ne koristi staru hyprlang sintaksu.
- Boje čitaj iz theme/palette (format ime=#hex). Ne hardkoduj hex vrednosti van palette fajla ako može da se izbegne.
- Slike su u theme/images.
- Ne pokreći sudo komande. Predloži ih, ja ih pokrećem.
- Jedna izmena po zadatku. Posle izmene objasni kratko na srpskom šta si promenila i zašto.
- Ne commituj sam, ja pregledam diff i commitujem.
EOF