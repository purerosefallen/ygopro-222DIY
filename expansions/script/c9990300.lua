--コズミック・ブレイザー・ドラゴン
function c9990300.initial_effect(c)
	--Synchro
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9990300.negatecondition)
	e2:SetTarget(c9990300.negatetarget)
	e2:SetOperation(c9990300.negateoperation)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9990300.sptarget)
	e3:SetOperation(c9990300.spoperation)
	c:RegisterEffect(e3)
	--Revive
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCost(c9990300.rvcost)
	e4:SetTarget(c9990300.rvtarget)
	e4:SetOperation(c9990300.rvoperation)
	c:RegisterEffect(e4)
end
function c9990300.negatecondition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and Duel.IsChainNegatable(ev)
end
function c9990300.negatetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9990300.negateoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateActivation(ev)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if c:IsRelateToEffect(e) then
		g:AddCard(c)
	end
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c9990300.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9990300.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED)
		and c9990300.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9990300.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9990300.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9990300.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9990300.rvcostfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsFaceup() and c:IsLevelBelow(13)
end
function c9990300.rvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c9990300.rvcostfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		if cg:CheckWithSumEqual(Card.GetLevel,12,1,63) then
			e:SetLabel(1)
			return true
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cg=cg:SelectWithSumEqual(tp,Card.GetLevel,12,1,63)
	Duel.HintSelection(cg)
	Duel.SendtoDeck(cg,nil,2,REASON_COST)
end
function c9990300.rvtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
		else
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
		end
		return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:SetLabel(0)
end
function c9990300.rvoperation(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not c:IsCanBeSpecialSummoned(e,0,tp,true,false) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end