--夜鸦·抹杀者E
function c10115004.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3331),7,2)
	c:EnableReviveLimit()   
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10115004,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10115004)
	e1:SetOperation(c10115004.op)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10115004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10115004)
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

function c10115004.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	e1:SetOperation(c10115004.aclimit1)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	e2:SetOperation(c10115004.aclimit2)
	Duel.RegisterEffect(e2,tp)
	e2:SetLabelObject(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c10115004.econ)
	e3:SetValue(aux.TRUE)
	e3:SetLabel(0)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e4:SetOperation(c10115004.clear)
	e4:SetLabelObject(e3)
	Duel.RegisterEffect(e4,tp)
end

function c10115004.clear(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end

function c10115004.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	e:GetLabelObject():SetLabel(e:GetLabelObject():GetLabel()+1)
end

function c10115004.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	e:GetLabelObject():SetLabel(e:GetLabelObject():GetLabel()-1) 
end

function c10115004.econ(e)
	return e:GetLabel()>=2
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