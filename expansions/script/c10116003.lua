--紧急捕食令
function c10116003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(10116003,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,10116003+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCost(c10116003.cost)
	e1:SetTarget(c10116003.target)
	e1:SetOperation(c10116003.activate)
	c:RegisterEffect(e1)
	--lv down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10116003,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c10116003.lvcost)
	e2:SetOperation(c10116003.lvop)
	c:RegisterEffect(e2)
end
function c10116003.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c10116003.lvop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3331))
	e1:SetValue(-3)
	Duel.RegisterEffect(e1,tp)
end
function c10116003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10116003.tfilter(c)
	return c:IsSetCard(0x3331) and c:IsFaceup()
end
function c10116003.costfilter(c,e,tp)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsSetCard(0x3331) and c:IsType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE))) and Duel.IsExistingMatchingCard(c10116003.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c)
end
function c10116003.filter(c,e,tp,rc)
	local lv=rc:GetOriginalLevel()
	if rc:IsType(TYPE_XYZ) then
	   lv=rc:GetOriginalRank()
	end
	return c:IsSetCard(0x3331) and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or rc:IsLocation(LOCATION_MZONE))) or c:IsAbleToHand()) and not c:IsCode(rc:GetCode()) and c:IsLevelBelow(lv)
end
function c10116003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()~=1 then return false end
	   e:SetLabel(0)
	   return Duel.IsExistingMatchingCard(c10116003.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,10116003)<=0
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10116003.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
	   Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,tp,2,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c10116003.activate(e,tp,eg,ep,ev,re,r,rp)
	local c,rc=e:GetHandler(),e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10116003.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,rc):GetFirst()
	if not tc then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(10116003,2))) then
	   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tc)
	end
end