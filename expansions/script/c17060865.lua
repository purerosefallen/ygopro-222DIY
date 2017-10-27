--搭档型技瑟＆丽芙
function c17060865.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c17060865.ffilter,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),true)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--special summon ＆ pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060865,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17060865)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c17060865.sptg)
	e1:SetOperation(c17060865.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060865,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c17060865.tdcon)
	e2:SetTarget(c17060865.tdtg)
	e2:SetOperation(c17060865.tdop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060865,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c17060865.discon)
	e3:SetTarget(c17060865.distg)
	e3:SetOperation(c17060865.disop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060865,3))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,170608651)
	e4:SetTarget(c17060865.pentg)
	e4:SetOperation(c17060865.penop)
	c:RegisterEffect(e4)
end
c17060865.is_named_with_Partner=1
c17060865.is_named_with_Skill_Field=1
c17060865.is_named_with_Million_Arthur=1
function c17060865.IsPartner(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Partner
end
function c17060865.IsSkill_Field(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Skill_Field
end
function c17060865.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060865.ffilter(c)
	return c17060865.IsSkill_Field(c)
end
function c17060865.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060865.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17060865.pcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060865.pcfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c17060865.pcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060865.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c17060865.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c17060865.tdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c17060865.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17060865.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c17060865.tdfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c17060865.chainlm)
end
function c17060865.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c17060865.tdfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c17060865.chainlm(e,rp,tp)
	return tp==rp
end
function c17060865.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c17060865.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c17060865.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c17060865.penfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060865.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c17060865.penfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c17060865.penfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c17060865.penfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c17060865.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end