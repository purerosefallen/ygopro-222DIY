--那津音の形見
function c114001193.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c114001193.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c114001193.handcon)
	c:RegisterEffect(e2)
end
function c114001193.filter(c)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c114001193.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c114001193.filter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(114001193,0)) then
			Duel.SendtoGrave(g,REASON_EFFECT)
			Duel.BreakEffect()
		end
	end
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end

function c114001193.hdfilter(c)
	return c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER)
end
function c114001193.hdfilter2(c)
	return c:IsFacedown() or not c:IsSetCard(0x221)
end
function c114001193.handcon(e)
	return Duel.IsExistingMatchingCard(c114001193.hdfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
		and not Duel.IsExistingMatchingCard(c114001193.hdfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end