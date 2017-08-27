--処刑の魔法陣
function c114000340.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c114000340.target)
	e1:SetOperation(c114000340.activate)
	c:RegisterEffect(e1)
end

function c114000340.filter(c,e,tp,atk)
	local atk=c:GetAttack()
	return c:IsFaceup()
	and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) ) --0x224
	and Duel.IsExistingMatchingCard(c114000340.dfilter,tp,0,LOCATION_MZONE,1,nil,atk)
	and c:GetAttackAnnouncedCount()==0
end
function c114000340.dfilter(c,atk)
	return c:IsFaceup() and c:IsDestructable() and c:GetAttack()<atk
end
function c114000340.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c114000340.filter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c114000340.filter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local dg=Duel.GetMatchingGroup(c114000340.dfilter,tp,0,LOCATION_MZONE,tc,tc:GetAttack())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1,true)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end

function c114000340.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local dg=Duel.GetMatchingGroup(c114000340.dfilter,tp,0,LOCATION_MZONE,tc,tc:GetAttack())
		if dg:GetCount()>0 then
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end