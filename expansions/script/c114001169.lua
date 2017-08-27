--力の目覚め
function c114001169.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c114001169.condition)
	e1:SetTarget(c114001169.target)
	e1:SetOperation(c114001169.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c114001169.handcon)
	c:RegisterEffect(e2)
end
function c114001169.confilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x221)
end
function c114001169.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and not Duel.IsExistingMatchingCard(c114001169.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c114001169.filter(c,e,tp)
	return c:IsSetCard(0x221) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114001169.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114001169.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c114001169.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT+TYPE_SPELL+TYPE_TRAP)
end
function c114001169.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c114001169.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	--shuffle
	local shuf=false
	if not tc:IsLocation(LOCATION_DECK) then shuf=true end
	--shuffle
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		local optn=0
		local sel=3
		local retg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
		local disg=Duel.GetMatchingGroup(c114001169.disfilter,tp,0,LOCATION_ONFIELD,nil)
		if retg:GetCount()>0 then optn=optn+1 end
		if disg:GetCount()>0 then optn=optn+2 end
		if optn==1 and Duel.SelectYesNo(tp,aux.Stringid(114001169,0)) then sel=1 end
		if optn==2 and Duel.SelectYesNo(tp,aux.Stringid(114001169,1)) then sel=2 end
		if optn==3 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114001169,2))
			sel=Duel.SelectOption(tp,aux.Stringid(114001169,3),aux.Stringid(114001169,4),aux.Stringid(114001169,5))+1
		end
		if sel==1 then
			local retc=retg:Select(tp,1,1,nil)
			Duel.HintSelection(retc)
			Duel.BreakEffect()
			Duel.SendtoHand(retc,nil,REASON_EFFECT)
		end
		if sel==2 then
			local disc=disg:Select(tp,1,1,nil)
			Duel.HintSelection(disc)
			local disctc=disc:GetFirst()
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
			disctc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
			disctc:RegisterEffect(e2)
		end
		if shuf then Duel.ShuffleDeck(tp) end
	end
end

function c114001169.hdfilter(c)
	return c:IsFaceup() and ( c:IsLevelAbove(5) or c:IsType(TYPE_XYZ) )
end
function c114001169.handcon(e)
	return Duel.IsExistingMatchingCard(c114001169.hdfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end