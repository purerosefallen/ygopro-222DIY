--口袋妖怪 大钢蛇
function c80000188.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),6,3)
	c:EnableReviveLimit()  
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c80000188.indval)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000188,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c80000188.cost)
	e4:SetCountLimit(1)
	e4:SetCondition(c80000188.descon)
	e4:SetTarget(c80000188.destg)
	e4:SetOperation(c80000188.desop)
	c:RegisterEffect(e4)  
end
function c80000188.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000188.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ 
end
function c80000188.indval(e,c)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c80000188.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c80000188.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,80000187)
end
function c80000188.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c1=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	local c2=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	if (c1>c2 and c2~=0) or c1==0 then c1=c2 end
	if c1~=0 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,c1,0,0)
	end
end
function c80000188.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	if g1:GetCount()>0 or g2:GetCount()>0 then
		if g1:GetCount()==0 then
			Duel.Destroy(g2,REASON_EFFECT)
		elseif g2:GetCount()==0 then
			Duel.Destroy(g1,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,0)
			local ac=Duel.SelectOption(tp,aux.Stringid(80000188,2),aux.Stringid(80000188,3))
			if ac==0 then Duel.Destroy(g1,REASON_EFFECT)
			else Duel.Destroy(g2,REASON_EFFECT) end
		end
	end
end
