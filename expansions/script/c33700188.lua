--圣山的神像
local m=33700188
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.linkcon)
	e0:SetOperation(cm.linkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_FLAG_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.splimcon)
	c:RegisterEffect(e2)
end
function cm.mfilter(c,lc)
	return c:IsFaceup() and c:IsLinkType(TYPE_RITUAL) and c:IsCanBeLinkMaterial(lc)
end
function cm.lcheck(g,tp,lc)
	return Duel.GetLocationCountFromEx(tp,tp,g,lc)>0 and not g:IsExists(cm.lfilter,1,nil,g)
end
function cm.lfilter(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function cm.linkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>=3 and Senya.CheckGroup(g,cm.lcheck,nil,3,3,tp,c)
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,0,nil)
	local g1=Senya.SelectGroup(tp,HINTMSG_LMATERIAL,g,cm.lcheck,nil,3,3,tp,c)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
end
function cm.rmfilter(c,e,tp,zone)
	return zone>0 and c:IsFacedown() and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP,tp,zone) and Duel.GetLocationCountFromEx(tp)>0
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_EXTRA,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_EXTRA,nil,e,tp,zone)
	if g:GetCount()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=g:RandomSelect(tp,1):GetFirst()
	if Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP,zone) then
		e:GetHandler():SetCardTarget(tc)
		e:SetLabelObject(tc)
		Duel.SpecialSummonComplete()
	end
end
function cm.splimcon(e)
	return e:GetHandler():GetCardTarget():IsContains(e:GetLabelObject())
end
