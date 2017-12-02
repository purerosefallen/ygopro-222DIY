--库拉丽丝-连系
function c57300023.initial_effect(c)
	c:EnableReviveLimit()
	xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
	miyuki.AddXyzProcedureClariS(c,2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetDescription(aux.Stringid(57300023,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,57300023)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c57300023.cost)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.DiscardHand(1-tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	end)
	c:RegisterEffect(e1)
end
function c57300023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
