--水之歌
function c80090028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c80090028.condition)
	e1:SetTarget(c80090028.target)
	e1:SetOperation(c80090028.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c80090028.handcon)
	c:RegisterEffect(e2)   
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80090028,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c80090028.discost)
	e3:SetTarget(c80090028.distg)
	e3:SetOperation(c80090028.disop)
	c:RegisterEffect(e3) 
end
function c80090028.filter(c)
	return c:IsFaceup() and c:GetOriginalCode()==80090016
end
function c80090028.handcon(e)
	return Duel.IsExistingMatchingCard(c80090028.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80090028.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52d4) 
end
function c80090028.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80090028.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80090028.filter1(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c80090028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80090028.filter1,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c80090028.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c80090028.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80090028.filter1,tp,0,LOCATION_MZONE,nil)
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
		local og=Duel.GetOperatedGroup()
		local tc=og:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=og:GetNext()
		end
	end
end
function c80090028.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80090028.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetChainLimit(c80090028.limit(g:GetFirst()))
end
function c80090028.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c80090028.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end