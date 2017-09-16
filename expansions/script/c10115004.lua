--夜鸦·抹杀者E
function c10115004.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3331),7,2)
	c:EnableReviveLimit()   
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10115004,0))
	e1:SetCategory(CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1)
	e1:SetCost(c10115004.cost)
	e1:SetOperation(c10115004.op)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10115004,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCondition(c10115004.spcon)
	e2:SetCost(c10115004.spcost)
	e2:SetTarget(c10115004.sptg)
	e2:SetOperation(c10115004.spop)
	c:RegisterEffect(e2) 
	--fuck then condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c10115004.spop2)
	c:RegisterEffect(e3) 
end
function c10115004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10115004.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac2=Duel.AnnounceCard(tp,TYPE_SPELL+TYPE_TRAP)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(c10115004.bantg)
	e1:SetLabel(ac)
	e1:SetValue(ac2)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c10115004.bantg(e,c)
	return c:IsCode(e:GetLabel()) or c:IsCode(e:GetValue())
end
function c10115004.spop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10115104,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c10115004.spcon(e)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():GetFlagEffect(10115104)==0 
end
function c10115004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c10115004.filter(c,e,tp,count)
	return ((c:IsLevelBelow(7) and count==1) or (c:GetLevel()==4 and count==2)) and c:IsSetCard(0x3331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10115004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return (Duel.IsExistingMatchingCard(c10115004.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,1) and ft>-1) or (Duel.IsExistingMatchingCard(c10115004.filter,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,e,tp,2) and ft>0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c10115004.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=nil
	if ft>=2 and Duel.IsExistingMatchingCard(c10115004.filter,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,e,tp,2) and Duel.SelectYesNo(tp,aux.Stringid(10115004,2)) then
	  g=Duel.SelectMatchingCard(tp,c10115004.filter,tp,LOCATION_DECK+LOCATION_HAND,0,2,2,nil,e,tp,2)
	else 
	  g=Duel.SelectMatchingCard(tp,c10115004.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,1)
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end