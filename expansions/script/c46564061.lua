--WL·含 香 鸢 粉 薇
local m=46564061
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcCodeFun(c,46564051,aux.FilterBoolFunction(cm.ffilter),1,true,true)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.condition1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(cm.condition2)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.operation2)
	c:RegisterEffect(e3)
end
function cm.ffilter(c)
	return not c:IsAttribute(ATTRIBUTE_WIND)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.tgfilter(c)
	if c:IsRace(RACE_PLANT) and c:IsAbleToGrave() then return true end
	return c:IsSetCard(0x65c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41
end
function cm.rfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.rfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetMZoneCount(tp)>0 end
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,cm.rfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(46564051) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
