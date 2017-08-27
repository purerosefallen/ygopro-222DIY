--夜鸦·追猎者C
function c10115003.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3331),6,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10115003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10114004)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c10115003.spcon)
	e1:SetCost(c10115003.spcost)
	e1:SetTarget(c10115003.sptg)
	e1:SetOperation(c10115003.spop)
	c:RegisterEffect(e1) 
	--immue
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10115003,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10114004)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10115003.imcost)
	e1:SetTarget(c10115003.imtg)
	e1:SetOperation(c10115003.imop)
	c:RegisterEffect(e1)	
	--fuck then condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c10115003.spop2)
	c:RegisterEffect(e3)	
end

function c10115003.spop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10115103,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
end

function c10115003.imfilter(c)
	return c:IsSetCard(0x3331) and c:IsFaceup()
end

function c10115003.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10115003.imfilter,tp,LOCATION_MZONE,0,1,nil) end
end

function c10115003.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectMatchingCard(tp,c10115003.imfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c10115003.efilter)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e1)
	end
end

function c10115003.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function c10115003.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c10115003.spcon(e)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():GetFlagEffect(10115103)==0  
end

function c10115003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end

function c10115003.filter(c,e,tp)
	return c:IsLevelBelow(7) and c:IsSetCard(0x3331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10115003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10115003.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end

function c10115003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10115003.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
	end
end