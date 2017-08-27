--忘却之海·孤咒
function c66678911.initial_effect(c)
	--Xyz
	aux.AddXyzProcedure(c,nil,5,2,function(c)
		return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x665) and c:GetOverlayCount()==0
	end,aux.Stringid(66678911,0),2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
		if Duel.SelectYesNo(tp,aux.Stringid(66678911,1)) then
			e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
			return true
		else return false end
	end)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(function(e,c)
		return e:GetHandler():GetOverlayCount()*-500
	end)
	c:RegisterEffect(e2)
end
