--ELF·伊芙衍生物
function c1190901.initial_effect(c)
	
end
--
c1190901.named_with_ELF=1
function c1190901.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--