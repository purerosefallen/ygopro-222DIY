--口袋妖怪 未知图腾
function c80000199.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c80000199.ffilter,3,2,nil,nil,5)
	c:EnableReviveLimit()  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000199,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c80000199.rmcost)
	e2:SetTarget(c80000199.target)
	e2:SetOperation(c80000199.operation)
	c:RegisterEffect(e2) 
end
function c80000199.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000199.ffilter(c)
	return  c:IsSetCard(0x2d0) and c:IsRace(RACE_PSYCHO)
end
function c80000199.filter(c)
	return c:IsAbleToRemove()
end
function c80000199.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000199.filter,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_EXTRA)
end
function c80000199.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):RandomSelect(tp,1)
	Duel.ConfirmCards(tp,g)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and c:IsFaceup() and c:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		local ba=tc:GetBaseAttack()
		local bc=tc:GetBaseDefense()
		local reset_flag=RESET_EVENT+0x1fe0000
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(reset_flag)
		e1:SetCode(EFFECT_SET_BASE_DEFENSE)
		e1:SetValue(bc)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(reset_flag)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(ba)
		c:RegisterEffect(e2)
	end
end