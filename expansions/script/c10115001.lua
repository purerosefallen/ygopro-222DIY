--夜鸦·寻觅者D
function c10115001.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3331),4,2,nil,nil,5)  
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10115001,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10115001)
	e1:SetTarget(c10115001.thtg)
	e1:SetOperation(c10115001.thop)
	c:RegisterEffect(e1)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10115001,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10115001)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCondition(c10115001.spcon)
	e2:SetCost(c10115001.spcost)
	e2:SetTarget(c10115001.sptg)
	e2:SetOperation(c10115001.spop)
	c:RegisterEffect(e2) 
	--fuck then condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c10115001.spop2)
	c:RegisterEffect(e3)	
end

function c10115001.spop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10115101,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c10115001.spcon(e)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():GetFlagEffect(10115101)==0 
end
function c10115001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c10115001.filter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsSetCard(0x3331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10115001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10115001.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end

function c10115001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10115001.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c10115001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local tg=og:Filter(Card.IsAbleToHand,nil)
	if chk==0 then return og:GetCount()>=2 and tg:GetCount()>=1 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end

function c10115001.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) 
	 local g=c:GetOverlayGroup():Filter(Card.IsAbleToHand,nil)
	   if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	   end
end
