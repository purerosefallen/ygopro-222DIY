--3L·Your Song
local m=37564850
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	Senya.AddSummonMusic(c,m*16+2,SUMMON_TYPE_LINK)
	aux.AddLinkProcedure(c,Senya.check_link_set_3L,2,2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return c:IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetFlagEffectLabel(m)
	end)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local code=c:GetFlagEffectLabel(m)
		c:ResetFlagEffect(m)
		Senya.GainEffect_3L(c,code)
	end)
	c:RegisterEffect(e0)
end
function cm.effect_operation_3L(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	return e1
end
function cm.SetMaterial(c,g)
	local efg=g:Filter(function(c) return c.effect_operation_3L end,nil)
	if efg:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,m*16)
		local tg=efg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.HintSelection(tg)
		c:RegisterFlagEffect(m,0xfe1000,0,1,tc:GetOriginalCode())
	end
	return Card.SetMaterial(c,g)
end