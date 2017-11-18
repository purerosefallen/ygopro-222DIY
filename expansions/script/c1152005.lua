--七色之翼·芙兰朵露
function c1152005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetTarget(c1152005.tg1)
	e1:SetOperation(c1152005.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c1152005.tg2)
	e2:SetOperation(c1152005.op2)
	c:RegisterEffect(e2)
--
end
--
c1152005.named_with_Fulan=1
function c1152005.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152005.named_with_Fulsp=1
function c1152005.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152005.tfilter1_1(c,e)
	return c:IsDestructable() and c:IsType(TYPE_SPELL) and c:IsFaceup()  and not c:IsImmuneToEffect(e) and not c:IsCode(1152999)
end
function c1152005.tfilter1_2(c)
	return c:IsDestructable()
end
function c1152005.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c1152005.tfilter1_1,tp,LOCATION_ONFIELD,0,1,nil,e) and Duel.IsExistingTarget(c1152005.tfilter1_2,tp,0,LOCATION_ONFIELD,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c1152005.tfilter1_1,tp,LOCATION_ONFIELD,0,1,1,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=Duel.SelectTarget(tp,c1152005.tfilter1_2,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
--
function c1152005.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) then
					local e1_1=Effect.CreateEffect(e:GetHandler())
					e1_1:SetType(EFFECT_TYPE_SINGLE)
					e1_1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1_1:SetReset(RESET_EVENT+0x47e0000)
					e1_1:SetValue(LOCATION_REMOVED)
					e:GetHandler():RegisterEffect(e1_1,true)
				end
			end
		end
	end
end
--
function c1152005.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsPreviousLocation(LOCATION_SZONE) end
end
--
function c1152005.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(1152005,0)) then
		local c=e:GetHandler()
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetCode(EFFECT_CHANGE_TYPE)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2_1:SetReset(RESET_EVENT+0x1fc0000)
		e2_1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		c:RegisterEffect(e2_1,true)
	end
end