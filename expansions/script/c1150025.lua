--水之绫
function c1150025.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c1150025.tg0)
	c:RegisterEffect(e0)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c1150025.limit1)
	e1:SetCondition(c1150025.con1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(c1150025.limit2)
	e2:SetCondition(c1150025.con2)
	c:RegisterEffect(e2)  
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,1150025)
	e3:SetTarget(c1150025.tg3)
	e3:SetOperation(c1150025.op3)
	c:RegisterEffect(e3)
end
--
function c1150025.tg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1150025.limit1(e,re,tp)
	return re:GetHandler():GetLocation()==LOCATION_HAND 
end  
--
function c1150025.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetControler()==Duel.GetTurnPlayer()
end
--
function c1150025.limit2(e,re,tp)
	return re:GetHandler():GetLocation()==LOCATION_HAND 
end  
--
function c1150025.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetControler()~=Duel.GetTurnPlayer()
end
--
function c1150025.tfilter3(c)
	return c:IsPosition(POS_FACEUP) and c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c1150025.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c1150025.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1150025.tfilter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1150025.tfilter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c1150025.ofilter3(c,e,tp,tap,tc)
	return c:IsSSetable() and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:GetOwner()==tap and c~=tc and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c1150025.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
			local tap=tc:GetOwner()
			local g=Duel.SelectMatchingCard(tap,c1150025.ofilter3,tap,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler(),e,tp,tap,tc)
			if g:GetCount()>0 then
				local tc2=g:GetFirst()
				Duel.SSet(tap,g,tap)
				local e3_1=Effect.CreateEffect(e:GetHandler())
				e3_1:SetType(EFFECT_TYPE_SINGLE)
				e3_1:SetCode(EFFECT_CANNOT_TRIGGER)
				e3_1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
				tc2:RegisterEffect(e3_1)				
			end
		end
	end
end





