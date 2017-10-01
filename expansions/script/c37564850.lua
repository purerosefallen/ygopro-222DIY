--3L·Your Song
local m=37564850
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	Senya.AddSummonMusic(c,m*16+2,SUMMON_TYPE_LINK)
	--Senya.CommonEffect_3L(c,m)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.linkcon)
	e0:SetOperation(cm.linkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
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
function cm.linkfilter1(c,tp,ec)
	return c:IsFaceup() and Senya.check_set_3L(c) and c:IsCanBeLinkMaterial(ec) and Duel.IsExistingMatchingCard(cm.linkfilter2,tp,LOCATION_MZONE,0,1,c,tp,c,ec)
end
function cm.linkfilter2(c,tp,lc,ec)
	return c:IsFaceup() and Senya.check_set_3L(c) and c:IsCanBeLinkMaterial(ec) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,lc),ec)>0
end
function cm.linkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.linkfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,cm.linkfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,cm.linkfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,g1:GetFirst(),c)
	g1:Merge(g2)
	local efg=g1:Filter(function(c) return c.effect_operation_3L end,nil)
	if efg:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,m*16)
		local tg=efg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.HintSelection(tg)
		e:GetHandler():RegisterFlagEffect(m,0xfe1000,0,1,tc:GetOriginalCode())
	end
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
end