--★水の魔女っ娘 Frozen Aqua
function c114000869.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114000869.condition)
	e1:SetTarget(c114000869.target)
	e1:SetOperation(c114000869.operation)
	c:RegisterEffect(e1)
end
function c114000869.spfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x221)
end
function c114000869.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp and not Duel.IsExistingMatchingCard(c114000869.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c114000869.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c114000869.gfilter(c)
	return c:IsSetCard(0x221) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGrave()
end
function c114000869.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c114000869.gfilter,tp,LOCATION_DECK,0,nil)
	if sg:GetCount()>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(114000869,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=sg:Select(tp,1,1,nil)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_MUST_BE_ATTACKED)
		e2:SetValue(aux.imval1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_EP)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(0,1)
		e3:SetCondition(c114000869.atcon)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
		--atk up
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(800)
		e4:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e4)
		--attribute
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_ADD_ATTRIBUTE)
		e5:SetValue(ATTRIBUTE_LIGHT)
		e5:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e5)
	end
end
function c114000869.atcon(e)
	return Duel.IsExistingMatchingCard(Card.IsAttackable,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end