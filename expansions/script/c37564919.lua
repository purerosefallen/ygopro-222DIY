--Sayuri·天空的狂诗曲
local m=37564919
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_sayuri=true
function cm.initial_effect(c)
	Senya.AddSummonMusic(c,m*16,SUMMON_TYPE_LINK)
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
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37564765,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	Senya.NegateEffectModule(c,1,nil,cm.cost)
end
function cm.mfilter(c,lc)
	return c:IsFaceup() and Senya.check_set_sayuri(c) and c:IsLinkType(TYPE_RITUAL) and c:IsCanBeLinkMaterial(lc)
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
	local g1=Senya.SelectGroup(tp,0,g,cm.lcheck,nil,3,3,tp,c)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
end
function cm.cfilter(c,g)
	return g:IsContains(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function cm.filter(c,e,tp,z)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP,tp,z) and Senya.check_set_sayuri(c) and c:GetLevel()==4
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local z=e:GetHandler():GetLinkedZone()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp,z) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,z) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,z)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local z=e:GetHandler():GetLinkedZone()
	local tc=Duel.GetFirstTarget()
	if z~=0 and tc:IsRelateToEffect(e) and tc:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP,tp,z) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP,z)
		tc:CompleteProcedure()
	end
end
