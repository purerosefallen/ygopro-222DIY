--法制城邦
function c10113053.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113053,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10113053.target)
	e2:SetOperation(c10113053.operation)
	c:RegisterEffect(e2)   
end
function c10113053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
	Duel.SetChainLimit(aux.FALSE)
end
function c10113053.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	--forbidden
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(c10113053.bantg)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--forbidden
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(c10113053.hintop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)	
end
function c10113053.hintop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():SetHint(CHINT_CARD,0)
end
function c10113053.bantg(e,c)
	return c:IsCode(e:GetLabel())
end