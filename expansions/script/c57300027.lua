--库拉丽丝-牡丹
local m=57300027
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x570),2,2)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.rmcon)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(57300021)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c)
		return e:GetHandler():GetLinkedGroup():IsContains(c)
	end)
	e1:SetValue(1)
	c:RegisterEffect(e1)	
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x570) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rmcon(e,c,og)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and c:IsFaceup() and not c:IsDisabled() and Duel.GetMZoneCount(tp)>0
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)  
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	sg:Merge(g)
end