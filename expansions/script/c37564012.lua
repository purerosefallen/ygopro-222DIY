--元素毁灭者·Aya Ayane
local m=37564012
local cm=_G["c"..m]

xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(0x12)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37564765,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(Senya.SelfReleaseCost)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)	
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)
end
function cm.sprfilter1(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and not c:IsType(TYPE_PENDULUM) and c:IsReleasable()
end
function cm.spcfilter(c)
	return Senya.check_set_rose(c) and not c:IsPublic()
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.sprfilter1,tp,0,LOCATION_MZONE,nil)	
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and Senya.CheckGroup(mg,Senya.CheckFieldFilter,nil,3,63,tp,c) and Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.spcfilter,tp,LOCATION_HAND,0,1,1,nil)
	local mg=Duel.GetMatchingGroup(cm.sprfilter1,tp,0,LOCATION_MZONE,nil)
	local g1=Senya.SelectGroup(tp,HINTMSG_TOGRAVE,mg,Senya.CheckFieldFilter,nil,3,63,tp,c)
	Duel.Hint(HINT_CARD,0,m)
	Duel.ConfirmCards(1-tp,g)
	Duel.Release(g1,REASON_COST)
	Duel.ShuffleHand(tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(aux.TRUE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsType(TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION+TYPE_LINK)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
