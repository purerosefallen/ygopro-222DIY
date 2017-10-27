--被湮没的真实 晓美焰
function c60151007.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--ng
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(60151002,0))
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_CHAINING)
	e11:SetCountLimit(1,60151099)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(c60151007.discon)
	e11:SetTarget(c60151007.distg)
	e11:SetOperation(c60151007.disop)
	c:RegisterEffect(e11)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151007,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,60151007)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c60151007.condition)
	e2:SetTarget(c60151007.target)
	e2:SetOperation(c60151007.operation)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151007,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,60151008)
	e3:SetCondition(c60151007.spcon2)
	e3:SetTarget(c60151007.sptg2)
	e3:SetOperation(c60151007.spop2)
	c:RegisterEffect(e3)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60151007,2))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCountLimit(1,60151008)
	e5:SetTarget(c60151007.sptg)
	e5:SetOperation(c60151007.spop)
	c:RegisterEffect(e5)
end
function c60151007.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and e:GetHandler():GetOriginalRace()==RACE_SPELLCASTER
end
function c60151007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=Duel.SelectOption(tp,aux.Stringid(60151002,2),aux.Stringid(60151002,3))
	e:SetLabel(opt)
	Duel.SetChainLimit(aux.FALSE)
end
function c60151007.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 and c:IsAbleToHand() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	else
		--negate
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60151001,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetOperation(c60151007.disop2)
		c:RegisterEffect(e1)
	end
end
function c60151007.discon2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
		and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and re:GetHandler()~=e:GetHandler()
end
function c60151007.chlimit(e,ep,tp)
	return tp==ep
end
function c60151007.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c60151007.chlimit)
end
function c60151007.disop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c60151007.cfilter(c,tp)
	return c:IsControler(tp) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5b23)
end
function c60151007.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60151007.cfilter,1,nil,tp)
end
function c60151007.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x5b23) and not c:IsForbidden()
end
function c60151007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,13-seq)
		and Duel.IsExistingMatchingCard(c60151007.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c60151007.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local seq=e:GetHandler():GetSequence()
	if not Duel.CheckLocation(tp,LOCATION_SZONE,13-seq) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c60151007.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c60151007.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7)
end
function c60151007.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c60151007.spfilter(c,e,tp)
	return c:IsSetCard(0x5b23) and not c:IsCode(60151007) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151007.spop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) then
			if e:GetHandler():IsLocation(LOCATION_HAND) then
				Duel.ConfirmCards(1-tp,e:GetHandler())
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(1,0)
				e1:SetValue(c60151007.aclimit)
				e1:SetLabel(e:GetHandler():GetCode())
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				if Duel.GetMZoneCount(tp)<=0 then return end
				local g=Duel.GetMatchingGroup(c60151007.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
				if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151007,3)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=g:Select(tp,1,1,nil)
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
function c60151007.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c60151007.filter3(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:IsDestructable()
end
function c60151007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151007.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c60151007.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60151007.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c60151007.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end