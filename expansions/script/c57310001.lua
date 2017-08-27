--ENS·绯色月下、狂咲之绝
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function c57310001.initial_effect(c)
	Senya.ens(c,57310001)
	Senya.NegateEffectModule(c,1,57310001,Senya.SelfReleaseCost,c57310001.con,Senya.ensop(57310001))
end
function c57310001.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end