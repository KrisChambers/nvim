-- Greek letter abbreviations
-- Format: $<Name>$ for uppercase, $<name>$ for lowercase
-- Usage: Type $<name>$ in insert mode to expand to the Greek letter

local abbreviation_mapping = {
    { "|-", "⊢"},
    {"$Alpha$", "<C-k>A*"},
    {"$Beta$", "<C-k>B*"},
    {"$Chi$", "<C-k>X*"},
    {"$Delta$", "<C-k>D*"},
    {"$Epsilon$", "<C-k>E*"},
    {"$Eta$", "<C-k>Y*"},
    {"$Gamma$", "<C-k>G*"},
    {"$Iota$", "<C-k>I*"},
    {"$Kappa$", "<C-k>K*"},
    {"$Lambda$", "<C-k>L*"},
    {"$Mu$", "<C-k>M*"},
    {"$Nu$", "<C-k>N*"},
    {"$Omega$", "<C-k>W*"},
    {"$Omicron$", "<C-k>O*"},
    {"$Phi$", "<C-k>F*"},
    {"$Pi$", "<C-k>P*"},
    {"$Psi$", "<C-k>Q*"},
    {"$Rho$", "<C-k>R*"},
    {"$Sigma$", "<C-k>S*"},
    {"$Tau$", "<C-k>T*"},
    {"$Theta$", "<C-k>H*"},
    {"$Upsilon$", "<C-k>U*"},
    {"$Xi$", "<C-k>C*"},
    {"$Zeta$", "<C-k>Z*"},

    {"$alpha$", "<C-k>a*"},
    {"$beta$", "<C-k>b*"},
    {"$chi$", "<C-k>x*"},
    {"$delta$", "<C-k>d*"},
    {"$epsilon$", "<C-k>e*"},
    {"$eta$", "<C-k>y*"},
    {"$gamma$", "<C-k>g*"},
    {"$iota$", "<C-k>i*"},
    {"$kappa$", "<C-k>k*"},
    {"$lambda$", "<C-k>l*"},
    {"$mu$", "<C-k>m*"},
    {"$nu$", "<C-k>n*"},
    {"$omega$", "<C-k>w*"},
    {"$omicron$", "<C-k>o*"},
    {"$phi$", "<C-k>f*"},
    {"$pi$", "<C-k>p*"},
    {"$psi$", "<C-k>q*"},
    {"$rho$", "<C-k>r*"},
    {"$sigma$", "<C-k>s*"},
    {"$tau$", "<C-k>t*"},
    {"$theta$", "<C-k>h*"},
    {"$upsilon$", "<C-k>u*"},
    {"$xi$", "<C-k>c*"},
    {"$zeta$", "<C-k>z*"},
}

local function ticks(inner)
    return '`'..inner..'`'
end

for _, value in ipairs(abbreviation_mapping) do
    vim.cmd.iabbrev(value[1], value[2])
    vim.cmd.iabbrev(ticks(value[1]), ticks(value[2]))
end


-- vim.cmd.iabbrev("|-", "⊢")
-- -- UPPERCASE (Alphabetical)
-- vim.cmd.iabbrev("$Alpha$", "<C-k>A*")
-- vim.cmd.iabbrev("$Beta$", "<C-k>B*")
-- vim.cmd.iabbrev("$Chi$", "<C-k>X*")
-- vim.cmd.iabbrev("$Delta$", "<C-k>D*")
-- vim.cmd.iabbrev("$Epsilon$", "<C-k>E*")
-- vim.cmd.iabbrev("$Eta$", "<C-k>Y*")
-- vim.cmd.iabbrev("$Gamma$", "<C-k>G*")
-- vim.cmd.iabbrev("$Iota$", "<C-k>I*")
-- vim.cmd.iabbrev("$Kappa$", "<C-k>K*")
-- vim.cmd.iabbrev("$Lambda$", "<C-k>L*")
-- vim.cmd.iabbrev("$Mu$", "<C-k>M*")
-- vim.cmd.iabbrev("$Nu$", "<C-k>N*")
-- vim.cmd.iabbrev("$Omega$", "<C-k>W*")
-- vim.cmd.iabbrev("$Omicron$", "<C-k>O*")
-- vim.cmd.iabbrev("$Phi$", "<C-k>F*")
-- vim.cmd.iabbrev("$Pi$", "<C-k>P*")
-- vim.cmd.iabbrev("$Psi$", "<C-k>Q*")
-- vim.cmd.iabbrev("$Rho$", "<C-k>R*")
-- vim.cmd.iabbrev("$Sigma$", "<C-k>S*")
-- vim.cmd.iabbrev("$Tau$", "<C-k>T*")
-- vim.cmd.iabbrev("$Theta$", "<C-k>H*")
-- vim.cmd.iabbrev("$Upsilon$", "<C-k>U*")
-- vim.cmd.iabbrev("$Xi$", "<C-k>C*")
-- vim.cmd.iabbrev("$Zeta$", "<C-k>Z*")
--
-- -- LOWERCASE (Alphabetical)
-- vim.cmd.iabbrev("$alpha$", "<C-k>a*")
-- vim.cmd.iabbrev("$beta$", "<C-k>b*")
-- vim.cmd.iabbrev("$chi$", "<C-k>x*")
-- vim.cmd.iabbrev("$delta$", "<C-k>d*")
-- vim.cmd.iabbrev("$epsilon$", "<C-k>e*")
-- vim.cmd.iabbrev("$eta$", "<C-k>y*")
-- vim.cmd.iabbrev("$finalsigma$", "<C-k>*s")
-- vim.cmd.iabbrev("$gamma$", "<C-k>g*")
-- vim.cmd.iabbrev("$iota$", "<C-k>i*")
-- vim.cmd.iabbrev("$kappa$", "<C-k>k*")
-- vim.cmd.iabbrev("$lambda$", "<C-k>l*")
-- vim.cmd.iabbrev("$mu$", "<C-k>m*")
-- vim.cmd.iabbrev("$nu$", "<C-k>n*")
-- vim.cmd.iabbrev("$omega$", "<C-k>w*")
-- vim.cmd.iabbrev("$omicron$", "<C-k>o*")
-- vim.cmd.iabbrev("$phi$", "<C-k>f*")
-- vim.cmd.iabbrev("$pi$", "<C-k>p*")
-- vim.cmd.iabbrev("$psi$", "<C-k>q*")
-- vim.cmd.iabbrev("$rho$", "<C-k>r*")
-- vim.cmd.iabbrev("$sigma$", "<C-k>s*")
-- vim.cmd.iabbrev("$tau$", "<C-k>t*")
-- vim.cmd.iabbrev("$theta$", "<C-k>h*")
-- vim.cmd.iabbrev("$upsilon$", "<C-k>u*")
-- vim.cmd.iabbrev("$xi$", "<C-k>c*")
-- vim.cmd.iabbrev("$zeta$", "<C-k>z*")
