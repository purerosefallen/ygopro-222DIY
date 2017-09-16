--夜鸦·TGRX-Ⅰ
function c10114010.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10114010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10114010)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c10114010.spcon)
	e1:SetCost(c10114010.spcost)
	e1:SetTarget(c10114010.sptg)
	e1:SetOperation(c10114010.spop)
	c:RegisterEffect(e1) 
	--disable search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10114010,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,10114010)
	e2:SetCondition(c10114010.dscon)
	e2:SetOperation(c10114010.dsop)
	c:RegisterEffect(e2)
	--fuck then condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c10114010.spop2)
	c:RegisterEffect(e3) 
	c10114010.specialsummon_effect=e2   
end
function c10114010.dscon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x3331)
end
function c10114010.dsop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(0,LOCATION_DECK)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(0,1)
	Duel.RegisterEffect(e2,tp) 
end
function c10114010.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and re:GetHandler():IsSetCard(0x3331) then
	   c:RegisterFlagEffect(10114010,RESET_EVENT+0x1ff0000,0,1)
	end
end
function c10114010.spcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function c10114010.filter(c,e,tp,count)
	return ((c:IsLevelBelow(7) and count==1) or ((e:GetLabel()==1 or e:GetHandler():GetFlagEffect(10114010)>0) and c:GetLevel()==4 and count==2)) and c:IsSetCard(0x3331) and not c:IsCode(10114010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10114010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10114010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return ((Duel.IsExistingMatchingCard(c10114010.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,1) and ft>-1) or (e:GetHandler():GetFlagEffect(10114010)>0 and Duel.IsExistingMatchingCard(c10114010.filter,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,e,tp,2) and ft>0)) and c:IsAbleToDeckAsCost()
	end
	if c:GetFlagEffect(10114010)>0 then e:SetLabel(1) end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c10114010.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=nil
	if ft>=2 and e:GetLabel()==1 and Duel.IsExistingMatchingCard(c10114010.filter,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,e,tp,2) and Duel.SelectYesNo(tp,aux.Stringid(10114010,1)) then
	  g=Duel.SelectMatchingCard(tp,c10114010.filter,tp,LOCATION_DECK+LOCATION_HAND,0,2,2,nil,e,tp,2)
	else 
	  g=Duel.SelectMatchingCard(tp,c10114010.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,1)
	end
	if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end