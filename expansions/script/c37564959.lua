--Sayuri·天空的狂诗曲 -SP Ver-
local m=37564959
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_sayuri=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e22:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e22)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.linkcon)
	e0:SetOperation(cm.linkop)
	--e0:SetValue(SUMMON_TYPE_LINK)
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
	return c:IsFaceup() and Senya.check_set_sayuri(c) and c:IsLinkType(TYPE_RITUAL) and c:IsReleasable()
end
function cm.lcheck(g,tp,lc)
	return Duel.GetMZoneCount(tp)+g:FilterCount(aux.FConditionCheckF,nil,tp)>0 and not g:IsExists(cm.lfilter,1,nil,g)
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
	local g1=Senya.SelectGroup(tp,HINTMSG_RELEASE,g,cm.lcheck,nil,3,3,tp,c)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function cm.cfilter(c,seq)
	return math.abs(c:GetSequence()-seq)==1
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,seq) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,seq)
	Duel.Release(g,REASON_COST)
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Senya.check_set_sayuri(c) and c:GetLevel()==4
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsCanBeSpecialSummoned(e,0,tp,true,true) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
