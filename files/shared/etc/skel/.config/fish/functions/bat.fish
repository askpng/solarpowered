if grep -q "Arch Linux" /etc/os-release
function bat --wraps=glow --description 'alias bat glow'
  glow $argv
end
end
