--守护·白猫
function c1110003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1110003)
	e1:SetTarget(c1110003.tg1)
	e1:SetOperation(c1110003.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,1110053)
	e2:SetCondition(c1110003.con2)
	e2:SetTarget(c1110003.tg2)
	e2:SetOperation(c1110003.op2)
	c:RegisterEffect(e2)
end
--
c1110003.named_with_Ld=1
function c1110003.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
function c1110003.IsLw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lw
end
function c1110003.IsDw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Dw
end
--
function c1110003.counterfilter(c)
	return c1110003.IsLd(c) and c:IsType(TYPE_MONSTER)
end
--
function c1110003.filter1(c,e,tp)
	return c1110003.IsLd(c) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1110003.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c1110003.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_HAND)
end
--
function c1110003.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if Duel.SelectYesNo(tp,aux.Stringid(1110003,1)) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_LEVEL)
			e3:SetValue(2)
			e3:SetReset(RESET_EVENT+0xfe0000)
			c:RegisterEffect(e3)
		end
	end
end
--
function c1110003.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
--
function c1110003.tfilter2(c)
	return (c1110003.IsLw(c) or c1110003.IsDw(c)) and c:IsSSetable()
end
function c1110003.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c1110003.tfilter2,tp,LOCATION_DECK,0,1,nil) end
end
--
function c1110003.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c1110003.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end

