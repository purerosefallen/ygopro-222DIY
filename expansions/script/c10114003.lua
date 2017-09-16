--夜鸦·TGS-Ⅲ
function c10114003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10114003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10114003)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c10114003.spcon)
	e1:SetCost(c10114003.spcost)
	e1:SetTarget(c10114003.sptg)
	e1:SetOperation(c10114003.spop)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10114003,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,10114003)
	e2:SetCondition(c10114003.thcon)
	e2:SetTarget(c10114003.thtg)
	e2:SetOperation(c10114003.thop)
	c:RegisterEffect(e2)   
	--fuck condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c10114003.spop2)
	c:RegisterEffect(e0)
	c10114003.specialsummon_effect=e2
end
function c10114003.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and re:GetHandler():IsSetCard(0x3331) then
	   c:RegisterFlagEffect(10114003,RESET_EVENT+0x1ff0000,0,1)
	end
end
function c10114003.spcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function c10114003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10114003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c10114003.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and c:IsAbleToDeckAsCost()
	end
	if c:GetFlagEffect(10114003)>0 then e:SetLabel(1) end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c10114003.filter(c,e,tp)
	local rc=e:GetHandler()
	return (c:GetLevel()==4 or ((e:GetLabel()==1 or rc:GetFlagEffect(10114003)>0) and c:GetLevel()==5)) and c:IsSetCard(0x3331) and not c:IsCode(10114003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10114003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10114003.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10114003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x3331)
end
function c10114003.thfilter(c)
	return c:IsSetCard(0x3331) and (c:IsAbleToHand() or (c:IsType(TYPE_SPELL) and c:IsSSetable()))
end
function c10114003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c10114003.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10114003.thfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not tc then return end
	local setable=tc:IsType(TYPE_SPELL) and tc:IsSSetable()
	if setable and (not tc:IsAbleToHand() or  Duel.SelectYesNo(tp,aux.Stringid(10114001,2))) then
	   Duel.SSet(tp,tc)
	else
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	Duel.ConfirmCards(1-tp,tc)
end
