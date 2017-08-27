--幻想的第三乐章·孤寂
function c60150515.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60150515.mfilter,10,2)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54719828,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c60150515.fuscon)
	e1:SetCost(c60150515.cost)
	e1:SetOperation(c60150515.operation)
	c:RegisterEffect(e1)
end
function c60150515.mfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60150515.fuscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=1
end
function c60150515.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60150515.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_MAX_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c60150515.value)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e2,tp)
    local c2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
    if c2>1 then
        local g=Group.CreateGroup()
        if c2>1 then
            Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
            local g2=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_MZONE,0,c2-1,c2-1,nil)
            g:Merge(g2)
        end
        Duel.SendtoGrave(g,REASON_RULE)
        Duel.Readjust()
    end
end
function c60150515.value(e,fp,rp,r)
	return 1
end