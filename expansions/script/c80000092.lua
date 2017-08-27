--口袋妖怪 阿勃梭鲁
function c80000092.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit() 
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000092,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c80000092.descost)
	e2:SetTarget(c80000092.target)
	e2:SetOperation(c80000092.desop)
	c:RegisterEffect(e2)
	--xyz summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c80000092.xyzcon)
	e3:SetOperation(c80000092.xyzop)
	e3:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e3)
	--ack
	--attack twice
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c80000092.condition)
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c80000092.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c80000092.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function c80000092.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x2d0) and c:GetRank()==5 and c:IsCanBeXyzMaterial(xyzc)
		and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c80000092.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if 2<=ct then return false end
	if ct<1 and not og and Duel.IsExistingMatchingCard(c80000092.ovfilter,tp,LOCATION_MZONE,0,1,nil,tp,c) then
		return true
	end
	return Duel.CheckXyzMaterial(c,nil,6,2,2,og)
end
function c80000092.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct=-ft
		local b1=Duel.CheckXyzMaterial(c,nil,6,2,2,og)
		local b2=ct<1 and Duel.IsExistingMatchingCard(c80000092.ovfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
		if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(80000092,0))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=Duel.SelectMatchingCard(tp,c80000092.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
			mg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
			local mg2=mg:GetFirst():GetOverlayGroup()
			if mg2:GetCount()~=0 then
				Duel.Overlay(c,mg2)
			end
			c:SetMaterial(mg)
			Duel.Overlay(c,mg)
		else
			local mg=Duel.SelectXyzMaterial(tp,c,nil,6,2,2)
			c:SetMaterial(mg)
			Duel.Overlay(c,mg)
		end
	end
end
function c80000092.cfilter(c,e,tp)
	return c:IsAbleToDeckAsCost()
end
function c80000092.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000092.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c80000092.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c80000092.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_EFFECT) end
end
function c80000092.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_EFFECT)
end