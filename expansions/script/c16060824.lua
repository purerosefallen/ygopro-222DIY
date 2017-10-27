--暗堕型盗贼亚瑟
function c16060824.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--ep effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16060824,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c16060824.epcon)
	e1:SetTarget(c16060824.eptg)
	e1:SetOperation(c16060824.epop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16060824,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,16060824)
	e2:SetCost(c16060824.spcost)
	e2:SetTarget(c16060824.sptg)
	e2:SetOperation(c16060824.spop)
	c:RegisterEffect(e2)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16060824,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,160608241)
	e3:SetCost(c16060824.cost)
	e3:SetTarget(c16060824.target)
	e3:SetOperation(c16060824.activate)
	c:RegisterEffect(e3)
end
c16060824.named_with_Dark_Degenerate=true
function c16060824.epcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c16060824.eptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c16060824.epop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c16060824.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_PENDULUM) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_PENDULUM)
	Duel.Release(g,REASON_COST)
end
function c16060824.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c16060824.thfilter(c)
	return c:IsCode(16060825) and c:IsAbleToHand()
end
function c16060824.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	local g=Duel.GetMatchingGroup(c16060824.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(16060824,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=g:Select(tp,1,1,nil)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local tc=g:GetFirst()
	if tc then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16060824.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function c16060824.splimit(e,c)
	return not c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA)
end

function c16060824.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c16060824.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemove()
end
function c16060824.filter(c,e,tp,m1,m2,ft)
	if not c:IsCode(16060825) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,7,c)
	else
		return mg:IsExists(c16060824.mfilterf,1,nil,tp,mg,c)
	end
end
function c16060824.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,7,rc)
	else return false end
end
function c16060824.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		mg1:RemoveCard(e:GetHandler())
		local mg2=Duel.GetMatchingGroup(c16060824.mfilter,tp,LOCATION_GRAVE,0,nil)
		local ft=Duel.GetMZoneCount(tp)
		if e:GetHandler():IsLocation(LOCATION_MZONE) then ft=ft+1 end
		return ft>-1 and Duel.IsExistingMatchingCard(c16060824.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c16060824.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c16060824.mfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16060824.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,7,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c16060824.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,7,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

