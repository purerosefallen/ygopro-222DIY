--魔法少女·芙兰朵露
function c1152007.initial_effect(c)
--
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),4,2)
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1152007.con1)
	e1:SetCost(c1152007.cost1)
	e1:SetTarget(c1152007.tg1)
	e1:SetOperation(c1152007.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c1152007.tg2)
	e2:SetOperation(c1152007.op2)
	c:RegisterEffect(e2)
--
end
--
c1152007.named_with_Fulan=1
function c1152007.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152007.named_with_Fulsp=1
function c1152007.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152007.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
--
function c1152007.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
--
function c1152007.tfilter1_1(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToRemove() and bit.band(c:GetReason(),REASON_DESTROY)~=0
end
function c1152007.tfilter1_2(c)
	return c:IsDestructable() and c:IsAbleToRemove()
end
function c1152007.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c1152007.tfilter1_1,tp,LOCATION_GRAVE,0,nil)>0 and Duel.GetMatchingGroupCount(c1152007.tfilter1_2,tp,0,LOCATION_EXTRA,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
--
function c1152007.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1152007.tfilter1_1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g and g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		if g2 and g2:GetCount()>0 then
			local sg=g2:RandomSelect(tp,1)
			if Duel.Destroy(sg,REASON_EFFECT)~=0 then
				Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end
--
function c1152007.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsPreviousLocation(LOCATION_SZONE) end
end
--
function c1152007.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(1152007,0)) then
		local c=e:GetHandler()
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end