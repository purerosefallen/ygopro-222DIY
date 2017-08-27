--魔女に与える鉄槌(マレウス･マレフィカルム)
function c114000569.initial_effect(c)
        --Activate
        local e1=Effect.CreateEffect(c)
        e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
        e1:SetType(EFFECT_TYPE_ACTIVATE)
        e1:SetCode(EVENT_FREE_CHAIN)
        e1:SetHintTiming(0,0x1e0)
        e1:SetTarget(c114000569.target)
        e1:SetOperation(c114000569.activate)
        c:RegisterEffect(e1)
end
function c114000569.filter(c)
        return c:IsFaceup() and c:IsDestructable()
		and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) --0x224
		or c:IsSetCard(0xcabb) ) 
end
function c114000569.target(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then return Duel.IsExistingMatchingCard(c114000569.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
        local g=Duel.GetMatchingGroup(c114000569.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
end
function c114000569.activate(e,tp,eg,ep,ev,re,r,rp)
        local g=Duel.GetMatchingGroup(c114000569.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local ct=Duel.Destroy(g,REASON_EFFECT)
        Duel.Damage(1-tp,ct*800,REASON_EFFECT)
end