  if grep -q "Arch Linux" /etc/os-release                                                                             
  atuin init fish | source                                                                                            
  end

if grep -q "Arch Linux" /etc/os-release
function cat --wraps=glow --description 'alias cat glow'
  glow $argv
end        
end
