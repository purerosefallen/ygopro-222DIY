--Darkest　赏金猎人
function c22230004.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230004,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c22230004.postg)
	e1:SetOperation(c22230004.posop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetOperation(c22230004.flipop)
	c:RegisterEffect(e2)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230004,2))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCountLimit(1,22230004)
	e1:SetTarget(c22230004.sptg)
	e1:SetOperation(c22230004.spop)
	c:RegisterEffect(e1)
end
c22230004.named_with_Darkest_D=1
function c22230004.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22230004.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not (c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM))
end
function c22230004.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c22230004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22230004.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22230004.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	if e:GetHandler():GetFlagEffect(22230004)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(22230004)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c22230004.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_SZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN)
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22230004,1))  then
		local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
		if dg then Duel.Destroy(dg,REASON_EFFECT) end
	end
end
function c22230004.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(22230004,0,0,0)
end
function c22230004.spfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FLIP) and c22230004.IsDarkest(c)
end
function c22230004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22230004.spfilter(chkc) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.IsExistingTarget(c22230004.spfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22230004.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22230004.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		if Duel.ChangePosition(tc,POS_FACEDOWN)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsRelateToEffect(e) then
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		end
	end
end