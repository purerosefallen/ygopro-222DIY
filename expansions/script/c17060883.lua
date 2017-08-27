--小天使
function c17060883.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetCondition(c17060883.incon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e2)
	--atk limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c17060883.atlimit)
	c:RegisterEffect(e4)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_CONTROL)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,0x1e0)
	e5:SetCountLimit(1,17060883)
	e5:SetCondition(c17060883.ctcon)
	e5:SetTarget(c17060883.cttg)
	e5:SetOperation(c17060883.ctop)
	c:RegisterEffect(e5)
	--
	if not Card.IsLinkState then
		function Card.IsLinkState(c)
			if not c then return false end
			if c:IsType(TYPE_LINK) and c:GetLinkedGroupCount()>0 then return true end
			local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
			local lc=g:GetFirst()
			while lc do
				local lg=lc:GetLinkedGroup()
				if lg and lg:IsContains(c) then return true end
				lc=g:GetNext()
			end
			return false
		end
	end
end
function c17060883.incon(e)
	local c=e:GetHandler()
	return c:IsLinkState()
end
function c17060883.atlimit(e,c)
	return c~=e:GetHandler()
end
function c17060883.ctcon(e,c,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>=2
end
function c17060883.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c17060883.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end