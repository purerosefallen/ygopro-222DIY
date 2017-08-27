--青之世界
function c1150007.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c1150007.tg0)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c1150007.limit1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_FLIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCountLimit(1,1150007)
	e2:SetCondition(c1150007.con2)
	e2:SetTarget(c1150007.tg2)
	e2:SetOperation(c1150007.op2)
	c:RegisterEffect(e2)
--
end
--
function c1150007.tg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1150007.limit1(e,re,tp)
	return re:GetHandler():IsType(TYPE_TRAP) and re:GetHandler():IsLocation(LOCATION_HAND)
end
--
function c1150007.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
--
function c1150007.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,LOCATION_FZONE)
end
--
function c1150007.ofilter2(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c1150007.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(c1150007.ofilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			if g:GetCount()>0 then
				Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end

