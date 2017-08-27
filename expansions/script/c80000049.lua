--口袋妖怪 三地鼠
function c80000049.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),3,3)
	c:EnableReviveLimit() 
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,0xff)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetCondition(c80000049.condition)
	e2:SetTarget(c80000049.rmtg)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000049,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c80000049.regcon)
	e1:SetCost(c80000049.cost)
	e1:SetTarget(c80000049.destg)
	e1:SetOperation(c80000049.desop)
	c:RegisterEffect(e1)
end
function c80000049.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end  
function c80000049.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,80000048)
end
function c80000049.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c80000049.desop(e,tp,eg,ep,ev,re,r,rp)
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==3 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif c1+c2+c3==0 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,0,nil)
		Duel.Destroy(g,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)	  
	end
end
function c80000049.regcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil) or e:GetHandler()==Duel.GetAttackTarget()
end
function c80000049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end