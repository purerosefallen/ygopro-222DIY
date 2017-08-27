--冰雪元素·布利扎 
local m=37564004
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
		--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,63)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(0x14000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and (not c:IsType(TYPE_PENDULUM))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.filter,1,e:GetHandler(),tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsPreviousLocation(LOCATION_EXTRA) and (not c:IsType(TYPE_PENDULUM))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter2,e:GetHandler(),e,tp)
	Duel.Destroy(g,REASON_EFFECT)
end
